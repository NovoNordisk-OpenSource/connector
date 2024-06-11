# test_that("Tools for backend creation", {
#   example_with_metadata <- "{metadata.trial}/adam"
#
#   expect_true(
#     custom_path_or_not(example_with_metadata)
#   )
#
#   infos <- extract_info_from_metadata(yaml_content["metadata"], example_with_metadata)
#
#   expect_equal(
#     infos,
#     c("metadata.trial" = "demo_trial")
#   )
#
#   expect_error(
#     extract_info_from_metadata(
#       yaml_content["metadata"],
#       "{connections[[1]].backend.extra_class}"
#     )
#   )
#
#   expect_equal(
#     extract_custom_path(yaml_content, example_with_metadata),
#     "demo_trial/adam"
#   )
#
#   example_without_metadata <- "adam"
#
#   expect_false(
#     custom_path_or_not(example_without_metadata)
#   )
#
#   expect_equal(
#     extract_custom_path(yaml_content, example_without_metadata),
#     "adam"
#   )
# })
#
