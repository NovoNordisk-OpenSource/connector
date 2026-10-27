connector_contract_tests()$run(
  new_connector = \(env) connector_fs(withr::local_tempdir(.local_envir = env))
)
