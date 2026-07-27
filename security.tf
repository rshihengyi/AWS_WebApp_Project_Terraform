/*
    The RDS is allowed to accept traffic from the worker nodes using port 5432
*/

resource "aws_security_group" "rds_sg" {
  name   = "rds-sg"
  vpc_id = aws_vpc.my_vpc.id

  ingress = [
    {
      description = "Allow traffic from worker nodes to RDS"

      /* 
        **Note: Choosing the port number is engine specific.
        Every service specifies which TCP/UDP port it listens on by default

      */

      from_port       = 5432 // Default port for PostgreSQL connections over TCP
      to_port         = 5432
      protocol        = "tcp"
      security_groups = [module.eks.node_security_group_id]
      #source_security_group_id = [module.eks.node_security_group_id]
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      self             = false

    }
  ]

  //  RDS can send out traffic anywhere with any protocol
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Terraform = "true"
  }
}
