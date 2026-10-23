run_connector_contract_tests(
  connector_contract_tests(),
  new_connector = \(env) connector_fs(withr::local_tempdir(.local_envir = env))
)
