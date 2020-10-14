/*
Eventually, the goal is to create necessary databases on the
RDS MySQL instance. This was an early (and incomplete) attempt
to do so. This syntax should be correct, or close to it, but
needs to be executed strictly from the director instance.
*/

# locals {
#   mysql_databases = [
#     "edxapp",
#     "edxapp_csmh",
#     "xqueue",
#     "notes_api",
#     "ecommerce"
#   ]

#   mysql_users = [
#     "ecommerce"
#   ]
# }

# resource "mysql_database" "databases" {
#   foreach = toset(local.mysql_databases)

#   provider              = mysql.aws_rds
#   name                  = each.value
#   default_character_set = "utf8"
# }

# resource "mysql_user" "users" {
#   foreach = toset(local.mysql_users)

#   provider = mysql.aws_rds
#   user     = each.value
# }
