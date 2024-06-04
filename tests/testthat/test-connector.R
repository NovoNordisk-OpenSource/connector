test_that("can create Connector object", {
    connector_obj <- Connector(
        "test"
    )

    expect_s3_class(connector_obj, "Connector")
})

test_that("Connect datasources to the connections for a yaml file", {
    # create the connections
    connect <- connect_from_yaml(yaml_content) %>%
        expect_no_error()

    expect_s3_class(connect, "Connector")
    expect_named(connect, c("adam", "sdtm"))

    ## write and read for a system file

    connect$adam$read("adsl.csv") %>%
        expect_s3_class("data.frame")
    expect_error(connect$adam$read("do_not_exits.csv"))

    connect$adam$write(data.frame(a = 1:10, b = 11:20), "example.csv") %>%
        expect_no_error()

    expect_no_error(connect$adam$read("example.csv"))
    expect_no_error(connect$adam$remove("example.csv"))
    expect_error(connect$adam$read("example.csv"))

    ## write and read for a dbi connection
    expect_no_error(connect$sdtm$write(iris, "iris"))

    expect_no_error(connect$sdtm$read("iris"))

    ## Manipulate a table with the database

    iris_f <- connect$sdtm$tbl("iris") %>%
        dplyr::filter(Sepal.Length > 5)

    expect_s3_class(iris_f, "tbl_dbi")

    expect_snapshot_output(iris_f %>% dplyr::collect())
})
