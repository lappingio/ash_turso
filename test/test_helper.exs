run_integration? = System.get_env("RUN_INTEGRATION_TESTS") == "true"

if run_integration? do
  ExUnit.start()
else
  ExUnit.start(exclude: [integration: true])
end
