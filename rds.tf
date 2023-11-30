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

# ---------------------------------------------
# RDS subnet group
# ---------------------------------------------
resource "aws_db_subnet_group" "mysql_standalone_subnetgroup" {
  name = "${var.project}-${var.environment}-mysql-standalone-subnetgroup" // 名
  // 配列サブネットID
  subnet_ids = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1c.id
  ]

  // タグ
  tags = {
    Name    = "${var.project}-${var.environment}-mysql-standalone-subnetgroup"
    Project = var.project
    Env     = var.environment
  }
}

# ---------------------------------------------
# RDS instance
# ---------------------------------------------
resource "random_string" "db_password" {
  length  = 16  // 長さ
  special = false // 特殊文字を使うかどうか（デフォルトtrue）
}

resource "aws_db_instance" "mysql_standalone" {
  engine         = "mysql"  // DBエンジン
  engine_version = "8.0.20" // DBエンジンのバージョン

  identifier = "${var.project}-${var.environment}-mysql-standalone" // RDSインスタンスリソース名

  username = "admin"  // マスターDBのユーザー名
  password = random_string.db_password.result // マスターDBのPW

  instance_class = "db.t2.micro" // インスタンスクラス

  allocated_storage     = 20  // 割り当てるストレージサイズ（ギガバイト）
  max_allocated_storage = 50  // オートスケールさせる最大ストレージサイズ
  storage_type          = "gp2" // standard、gp2（SSD）、io1（IOPS SSD）
  storage_encrypted     = false // DBを暗号化するKMSIDまたはfalse

  multi_az               = false  // マルチAZ配置するかどうか
  availability_zone      = "ap-northeast-1a"  // シングルインスタンス時に配置するAZ
  db_subnet_group_name   = aws_db_subnet_group.mysql_standalone_subnetgroup.name // サブネットグループ名
  vpc_security_group_ids = [aws_security_group.db_sg.id]  // SGのID
  publicly_accessible    = false  // パブリックアクセス許可するかどうか
  port                   = 3306 // ポート番号

  name                       = "tastylog" // DB名
  parameter_group_name       = aws_db_parameter_group.mysql_standalone_parametergroup.name  // パラメータグループ名
  option_group_name          = aws_db_option_group.mysql_standalone_optiongroup.name  // オプショングループ名

  backup_window              = "04:00-05:00"  // バックアップを行う時間帯
  backup_retention_period    = 7  // バックアップを残す数
  maintenance_window         = "Mon:05:00-Mon:08:00"  // メンテナンスを行う時間帯
  auto_minor_version_upgrade = false  // 自動でマイナーバージョンアップグレードするか

  deletion_protection = true  // 削除防止するか
  skip_final_snapshot = false // 削除時のスナップショットをスキップするか

  apply_immediately = true  // 即時反映するか

  // タグ
  tags = {
    Name    = "${var.project}-${var.environment}-mysql-standalone"
    Project = var.project
    Env     = var.environment
  }
}
