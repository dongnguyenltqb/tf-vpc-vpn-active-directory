resource "aws_iam_instance_profile" "ec2Domain" {
  name = "awsEc2DomainVPNInstanceProfile"
  role = aws_iam_role.domain.name
}

resource "aws_iam_role" "domain" {
  name = "awsEc2DomainVPNInstanceRole"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "ec2.amazonaws.com"
          },
          "Effect" : "Allow",
        }
      ]
  })
}

resource "aws_iam_policy" "policy" {
  name = "policy-for-ec2-domain-instances-secret-read"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" : [
          "arn:aws:secretsmanager:ap-southeast-1:035916403994:secret:awsSeamlessDomainForADSecret-YZlndT"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "domainRoleAttachment" {
  role       = aws_iam_role.domain.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_role_policy_attachment" "domainRoleAttachmentAmazonSSMManagedInstanceCore" {
  role       = aws_iam_role.domain.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "domainRoleAttachmentAmazonSSMDirectoryServiceAccess" {
  role       = aws_iam_role.domain.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMDirectoryServiceAccess"
}
