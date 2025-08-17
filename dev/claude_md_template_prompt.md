# Template Prompt for Creating Developer Documentation (dev/ folder)

Use this prompt to generate comprehensive developer documentation in a `dev/` folder for R packages, following the pattern established in the connector package.

## Prompt Template

```
Create comprehensive developer documentation in a `dev/` folder for this R package. Analyze the package structure and create two main documentation files following this template:

## File 1: dev/README.md - Technical Architecture Guide

Create a detailed technical guide covering:

# Developer Documentation - [PACKAGE_NAME]

## What is [PACKAGE_NAME]?

[2-3 sentence description of the package's purpose and main value proposition]

## Package Structure

```
[PACKAGE_NAME]/
├── R/
│   ├── [main-files].R          # [Brief description]
│   └── [other-files].R         # [Brief description]
├── tests/testthat/             # Test suite
├── vignettes/                  # User documentation  
└── dev/                        # Developer documentation
```

## Key Files and Their Role

### Core Entry Points
[Document the main functions/files that serve as entry points]

**`R/[main-file].R`**
- [Description of main functionality]
- [Key functions it contains]
- [How it fits into the overall architecture]

### [Other Major Components]
[For each major component, create sections describing:]
- Purpose and responsibilities
- Key functions/classes
- Integration patterns
- File organization

## How [PACKAGE_NAME] Works

### [Main Workflow 1]
```
[step 1] → [step 2] → [step 3] → [output]
```

### [Main Workflow 2]  
```
[process flow diagram in text]
```

## Architecture Decisions

### [Main Design Pattern]
- [Explanation of core architectural choices]
- [Why this pattern was chosen]
- [How components interact]

### [Other Key Decisions]
[Document other important architectural decisions]

## Testing Structure

### Test Organization
- `test-[component].R`: [What this tests]
- [Other test files and their purposes]

### Test Patterns
- [Common testing approaches used]
- [Test utilities or fixtures]
- [Mock/stub patterns]

## Extension Points

### [How to extend the package]
1. [Step-by-step process for extensions]
2. [Required interfaces to implement]
3. [Naming conventions]
4. [Testing requirements]

## [Format/Protocol Support] (if applicable)
[Document supported formats, protocols, or integrations]

## [Special Systems] (if applicable)
[Document any logging, configuration, or other specialized systems]

## File 2: dev/quick-start.md - Developer Quick Start

Create a practical quick-start guide covering:

# Quick Start - [PACKAGE_NAME] Development

## Setup (5 minutes)

```bash
git clone [REPO_URL]
cd [PACKAGE_NAME]
R -e "devtools::install_deps(dependencies = TRUE)"
R -e "devtools::load_all(); devtools::test()"
```

## Test [PACKAGE_NAME] Works

```r
devtools::load_all()

# [Simple test of main functionality]
[example_code]

# [Test of secondary functionality]
[example_code]
```

## Test [Configuration/System] (if applicable)

```r
# [Example of testing configuration or advanced features]
[example_code]
```

## Development Workflow

### Making Changes

1. **Edit R files** in `R/` directory
2. **Reload package**: `devtools::load_all()`
3. **Test changes**: `devtools::test()`
4. **Check style**: `styler::style_pkg()`

### Adding a Function

```r
# [Example of adding a function with proper validation]
[example_code]
```

### Adding Tests

```r
# [Example of adding tests following package patterns]
[example_code]
```

## Working with [Main Components]

### [Component 1]

```r
# [Practical examples of using this component]
[example_code]
```

### [Component 2]

```r
# [Practical examples of using this component]  
[example_code]
```

## Debugging Common Issues

### [Common Issue 1]
```r
# [Solution code]
```

### [Common Issue 2]
```r
# [Solution code]
```

## Key Functions

```r
# Main API
[main_function()]          # [Description]
[other_function()]         # [Description]

# [Category] functions
[category_function()]      # [Description]

# Development tools
devtools::load_all()      # Reload package
devtools::test()          # Run tests
devtools::check()         # Full package check
```

## Next Steps

1. **Read [README.md]** for implementation details
2. **Browse R/ files** to understand code structure
3. **Check existing tests** for testing patterns
4. **Look at vignettes** for user examples

Please examine the package structure comprehensively including:

1. **DESCRIPTION file** for dependencies and package metadata
2. **All R/ files** to understand the architecture and key components
3. **Test structure** in tests/testthat/ to understand testing patterns
4. **Vignettes** (if any) to understand user-facing functionality
5. **Any configuration files** or special directories

Focus on creating documentation that helps developers:
- Quickly understand the package architecture
- Get up and running with development in minutes
- Understand common workflows and testing patterns
- Know how to extend or modify the package
- Debug common issues

Make both files practical and actionable for developers working with the code.
```

## Usage Instructions

1. **Copy the template prompt above**
2. **Navigate to your R package directory**  
3. **Paste the prompt into Claude Code**
4. **Claude will analyze your package and create the dev/ folder with comprehensive documentation**

## Key Benefits

This template creates developer documentation that includes:

- **Quick setup instructions** to get developers productive immediately
- **Architecture overview** explaining how the package is structured
- **Practical examples** for common development tasks
- **Testing guidance** following package-specific patterns
- **Debugging help** for common development issues
- **Extension patterns** for adding new functionality

## What Gets Created

The prompt will generate:

- `dev/README.md` - Comprehensive technical architecture guide
- `dev/quick-start.md` - Practical developer quick-start guide

Both files work together to give developers both the big picture and practical steps to be productive with your package.