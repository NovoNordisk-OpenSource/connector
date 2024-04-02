#' Create new repository based on template
#' @param repo New GitHub repository (owner/name)
#' @param template Template GitHub repository (owner/name)
#' @param use_standards [logical] apply settings and rules from the template repository?
#' @return [invisible] output from the GitHUb Api when creating the repository
#' @export

create_atmos_package <- function(repo, template = "NN-OpenSource/Rtemplate", use_standards = TRUE) {
  x <- gh::gh(
    "POST /repos/{template}/generate",
    template = template,
    owner = gsub(pattern = "/.*$", replacement = "", x = repo),
    name = gsub(pattern = "^.*/", replacement = "", x = repo),
    description = "New repository based on template",
    include_all_branches = FALSE,
    private = TRUE,
    .token = gh::gh_token()
  )

  if (use_standards) {
    Sys.sleep(2) # Make sure repo is generated before continuing
    use_atmos_rulesets(repo = repo, template = template)
    pages <- use_atmos_pages(repo = repo)
    use_atmos_settings(repo = repo, homepage = pages$html_url, template = template)
  }

  cli::cli({
    cli::cli_h1("New repository created")
    cli::cli_text("Github: ", cli::style_hyperlink(x$html_url, x$html_url))
    if (use_standards) {
      cli::cli_text("Webpage: ", cli::style_hyperlink(pages$html_url, pages$html_url))
    }
  })

  return(invisible(x))
}

#' Apply rule sets from template repository
#' @param repo New GitHub repository (owner/name)
#' @param template Template GitHub repository (owner/name)
#' @return [invisible] output from the GitHUb Api when creating the repository
#' @export

use_atmos_rulesets <- function(repo, template = "NN-OpenSource/Rtemplate") {
  rulesets <- gh::gh(
    "GET /repos/{template}/rulesets",
    template = template,
    .token = gh::gh_token()
  )

  rules <- vector(mode = "list", length = length(rulesets))
  for (i in seq_along(rules)) {
    rules[[i]] <- gh::gh(rulesets[[i]][["_links"]][["self"]][["href"]], .token = gh::gh_token())
    rules[[i]] <- rules[[i]][c("name", "target", "enforcement", "bypass_actors", "conditions", "rules")]
  }

  for (i in seq_along(rules)) {
    rules[[i]] <- gh::gh(
      "POST /repos/{repo}/rulesets",
      repo = repo,
      .params = rules[[i]],
      .token = gh::gh_token()
    )
  }

  return(invisible(rules))
}

#' Enable GitHUb Pages and get the url
#' @param repo GitHub repository (owner/name)
#' @return [invisible] output from the GitHUb Api when enabling Pages
#' @export

use_atmos_pages <- function(repo) {
  # Check if gh-pages branch exist

  gh_pages <- gh::gh(
    "GET /repos/{repo}/git/matching-refs/heads/gh-pages",
    repo = repo,
    .token = gh::gh_token()
  )

  # If not orphan branch is created
  # Using modified code from usethis:::create_gh_pages_branch

  if (!length(gh_pages)) {
    tree <- gh::gh(
      "POST /repos/{repo}/git/trees",
      repo = repo,
      tree = list(list(path = "_temp_file_ok_to_delete", mode = "100644", type = "blob", content = ""))
    )

    commit <- gh::gh(
      "POST /repos/{repo}/git/commits",
      repo = repo,
      message = "Init orphan branch",
      tree = tree$sha
    )

    gh::gh(
      "POST /repos/{repo}/git/refs",
      repo = repo,
      ref = "refs/heads/gh-pages",
      sha = commit$sha
    )

    gh::gh(
      "DELETE /repos/{repo}/contents/_temp_file_ok_to_delete",
      repo = repo,
      message = "Remove temp file",
      sha = tree[["tree"]][[1]][["sha"]],
      branch = "gh-pages"
    )
  }

  # Check if Pages is enabled

  pages <- gh::gh(
    "GET /repos/{repo}/pages",
    repo = repo,
    .token = gh::gh_token()
  )

  # If not, enable Pages and use branch gh-pages to deploy

  if (!length(pages)) {
    pages <- gh::gh(
      "POST /repos/{repo}/pages",
      repo = repo,
      .params = list(source = list(branch = "gh-pages")),
      .token = gh::gh_token()
    )

    # If yes, but branch is different, update

  } else if (is.null(pages$source$branch) || pages$source$branch != "gh-pages") {
    pages <- gh::gh(
      "PUT /repos/{repo}/pages",
      repo = repo,
      .params = list(source = list(branch = "gh-pages")),
      .token = gh::gh_token()
    )
  }

  # Return consistent output
  return(invisible(pages))
}

#' Apply settings from template repository and updates link to homepage
#' @param repo New GitHub repository (owner/name)
#' @param homepage URL of package webpage
#' @param template Template GitHub repository (owner/name)
#' @return [invisible] output from the GitHUb Api when creating the repository
#' @export

use_atmos_settings <- function(repo, homepage, template = "NN-OpenSource/Rtemplate") {
  tmpl_settings <- gh::gh(
    "GET /repos/{repo}",
    repo = template,
    .token = gh::gh_token()
  )

  # Extract selected settings, change homepage, and apply

  x <- c(
    "html_url", "homepage",
    "allow_squash_merge", "allow_merge_commit", "allow_rebase_merge",
    "allow_auto_merge", "delete_branch_on_merge", "allow_update_branch",
    "use_squash_pr_title_as_default"
  )

  settings <- tmpl_settings[x]
  settings[c("html_url", "homepage")] <- homepage

  gh::gh(
    "PATCH /repos/{repo}",
    repo = repo,
    .params = settings,
    .token = gh::gh_token()
  ) |>
    invisible()
}
