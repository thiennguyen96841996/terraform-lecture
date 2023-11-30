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

# ---------------------------------------------
# RDS option group
# ---------------------------------------------
resource "aws_db_option_group" "mysql_standalone_optiongroup" {
  name                 = "${var.project}-${var.environment}-mysql-standalone-optiongroup" // 名
  engine_name          = "mysql" // 関連付けるエンジン名
  major_engine_version = "8.0" // 関連づけるエンジンバージョン
}
