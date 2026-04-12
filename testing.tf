provider "aws" {
  region = "us-east-1"
}

# VIOLATES: 
# KMS-001 (Rotation disabled)
# KMS-002 (Policy allows deletion)
# KMS-003 (Key is disabled)
# KMS-004 (Multi-region replication missing region)
# KMS-005 (Insufficient description)
# KMS-006 (Missing required tags)
resource "aws_kms_key" "highly_vulnerable_key" {
  description             = "Short" # KMS-005: Less than 10 chars
  deletion_window_in_days = 7
  is_enabled              = false    # KMS-003: Key is disabled
  enable_key_rotation     = false    # KMS-001: Rotation not enabled
  multi_region            = true     # KMS-004: True but replication_region is missing

  # KMS-002: Key policy allows anyone (*) to delete the key
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowDirectDeletion"
        Effect = "Allow"
        Principal = {
          AWS = "*" # Wildcard principal
        }
        Action = [
          "kms:ScheduleKeyDeletion", # Explicitly checked in your _key_policy_allows_deletion
          "kms:*"
        ]
        Resource = "*"
      }
    ]
  })

  # KMS-006: Missing 'Environment', 'Owner', and 'CostCenter'
  tags = {
    Project = "SecurityTesting"
  }
}

# VIOLATES:
# KMS-007 (Naming convention)
# KMS-008 (AWS Reserved prefix)
resource "aws_kms_alias" "bad_alias" {
  name          = "my-bad-alias" # KMS-007: Missing 'alias/' prefix
  target_key_id = aws_kms_key.highly_vulnerable_key.key_id
}

resource "aws_kms_alias" "reserved_alias" {
  name          = "alias/aws/my-custom-key" # KMS-008: Contains 'aws/' in custom alias
  target_key_id = aws_kms_key.highly_vulnerable_key.key_id
}

# VIOLATES:
# KMS-009 (Dangerous operations)
# KMS-010 (Missing retiring principal)
resource "aws_kms_grant" "risky_grant" {
  name              = "risky-kms-grant"
  key_id            = aws_kms_key.highly_vulnerable_key.key_id
  grantee_principal = "arn:aws:iam::123456789012:role/some-role"
  
  # KMS-009: Includes ScheduleKeyDeletion and CreateGrant
  operations = ["Encrypt", "Decrypt", "ScheduleKeyDeletion", "CreateGrant"]

  # KMS-010: retiring_principal is omitted
}
