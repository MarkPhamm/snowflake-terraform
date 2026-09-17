# Template
# resource "snowflake_warehouse" "this" {
#   name                = "A"
#   comment             = "B"
#   warehouse_type      = "STANDARD/SNOWPARK-OPTIMIZED"
#   warehouse_size      = "XSMALL/SMALL/MEDIUM/..."
#   auto_suspend        = 60
#   auto_resume         = true/false
#   initially_suspended = true/false
#   max_cluster_count   = 1
#   min_cluster_count   = 1
# }

resource "snowflake_warehouse" "this" {
  name                = "TF_LEARN_WH"
  comment             = "Lesson 02 — X-Small warehouse for learning queries"
  warehouse_type      = "STANDARD"
  warehouse_size      = "XSMALL"
  auto_suspend        = 60
  auto_resume         = "true"
  initially_suspended = true
  max_cluster_count   = 1
  min_cluster_count   = 1
}
