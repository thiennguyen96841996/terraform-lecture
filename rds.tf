# ---------------------------------------------
# RDS parameter group
# ---------------------------------------------
resource "aws_db_parameter_group" "mysql_standalone_parametergroup" {
  name   = "${var.project}-${var.environment}-mysql-standalone-parametergroup"  // パラメータグループ名
  family = "mysql8.0" // パラメータグループのファミリー

  // 具体的なパラメータ
  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  // 具体的なパラメータ
  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}

