#!/usr/bin/env python3

"""
Bootstrap script for C++ template project.
Clones the template and prepares it for use as a new project.
"""

import argparse
import io
import json
import re
import shutil
import subprocess
import sys
from pathlib import Path

# Ensure stdout/stderr use UTF-8 encoding on Windows
if sys.platform == "win32":
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding="utf-8", errors="replace")


def parse_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser(
        description="Bootstrap a new C++ project from templ-project/cpp template",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Bootstrap in current directory
  uvx --from git+https://github.com/templ-project/cpp.git bootstrap .

  # Bootstrap in specific directory
  uvx --from git+https://github.com/templ-project/cpp.git bootstrap ./my-cpp-project

  # Bootstrap with custom project name
  uvx --from git+https://github.com/templ-project/cpp.git bootstrap --project-name awesome-lib ./my-project

  # Show help
  uvx --from git+https://github.com/templ-project/cpp.git bootstrap --help
        """,
    )

    parser.add_argument(
        "path",
        nargs="?",
        default=".",
        help="Target directory (default: current directory)",
    )

    parser.add_argument(
        "--project-name",
        help="Project name (default: extracted from target directory name)",
    )

    return parser.parse_args()


def remove_if_exists(target_path):
    """Remove a directory or file if it exists."""
    if target_path.exists():
        if target_path.is_dir():
            shutil.rmtree(target_path)
        else:
            target_path.unlink()
        print(f"  ✓ Removed: {target_path.name}")


def extract_project_name(target_path):
    """Extract project name from target directory path."""
    # Get the directory name
    dir_name = Path(target_path).name

    # Handle current directory case
    if dir_name in (".", ""):
        dir_name = Path.cwd().name

    # Convert to a valid project name
    # Replace spaces and underscores with hyphens, make lowercase
    project_name = dir_name.replace(" ", "-").replace("_", "-").lower()

    # Remove any non-alphanumeric characters except hyphens
    project_name = re.sub(r"[^a-z0-9-]", "", project_name)

    # Ensure it doesn't start or end with hyphens
    project_name = project_name.strip("-")

    # Fallback to default if empty
    if not project_name:
        project_name = "cpp-template"

    return project_name


def update_cmake_metadata(cmake_path, project_name):
    """Update CMakeLists.txt metadata for new project."""
    if not cmake_path.exists():
        return

    with open(cmake_path, "r", encoding="utf-8") as f:
        content = f.read()

    # Update project name and description
    content = content.replace(
        "project(\n    cpp-template", f"project(\n    {project_name}"
    )
    content = content.replace(
        'DESCRIPTION "A C++ Bootstrap/Template project using modern tools and best practices"',
        f'DESCRIPTION "{project_name.replace("-", " ").title()} project"',
    )

    with open(cmake_path, "w", encoding="utf-8") as f:
        f.write(content)

    print("  ✓ Updated CMakeLists.txt metadata")


def update_vcpkg_metadata(vcpkg_path, project_name):
    """Update vcpkg.json metadata for new project."""
    if not vcpkg_path.exists():
        return

    with open(vcpkg_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    # Update metadata
    data["name"] = project_name
    data["version"] = "0.1.0"
    data["description"] = f"{project_name.replace('-', ' ').title()} project"

    with open(vcpkg_path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2)
        f.write("\n")

    print("  ✓ Updated vcpkg.json metadata")


def update_xmake_metadata(xmake_path, project_name):
    """Update xmake.lua metadata for new project."""
    if not xmake_path.exists():
        return

    with open(xmake_path, "r", encoding="utf-8") as f:
        content = f.read()

    # Update project name and description
    content = content.replace(
        'set_project("cpp-template")', f'set_project("{project_name}")'
    )
    content = content.replace(
        'set_description("A C++ Bootstrap/Template project using modern tools and best practices")',
        f'set_description("{project_name.replace("-", " ").title()} project")',
    )

    # Update main target
    content = content.replace('target("cpp-template")', f'target("{project_name}")')

    # Update test target
    content = content.replace(
        'target("cpp-template-tests")', f'target("{project_name}-tests")'
    )

    with open(xmake_path, "w", encoding="utf-8") as f:
        f.write(content)

    print("  ✓ Updated xmake.lua metadata")


def update_taskfile_metadata(taskfile_path, project_name):
    """Update Taskfile.yml metadata for new project."""
    if not taskfile_path.exists():
        return

    with open(taskfile_path, "r", encoding="utf-8") as f:
        content = f.read()

    # Update PROJECT_NAME variable default value
    content = content.replace(
        "PROJECT_NAME: '{{default .PROJECT_NAME \"cpp-template\"}}'",
        f"PROJECT_NAME: '{{{{default .PROJECT_NAME \"{project_name}\"}}}}'",
    )

    with open(taskfile_path, "w", encoding="utf-8") as f:
        f.write(content)

    print("  ✓ Updated Taskfile.yml metadata")


def update_readme_metadata(readme_path, project_name):
    """Update README.md for new project."""
    if not readme_path.exists():
        return

    with open(readme_path, "r", encoding="utf-8") as f:
        content = f.read()

    # Create formatted project title
    project_title = project_name.replace("-", " ").replace("_", " ").title()

    # Update title and description
    content = content.replace("# C++ Bootstrap Template", f"# {project_title}")
    content = content.replace(
        "> A comprehensive C++ Bootstrap/Template project using modern tools and best practices",
        f"> {project_title} - A C++ project",
    )

    # Update bootstrap and clone commands
    content = content.replace(
        "uvx --from git+https://github.com/templ-project/cpp.git bootstrap ./my-cpp-project",
        f"uvx --from git+https://your-repo-url.git bootstrap ./{project_name}",
    )
    content = content.replace(
        "git clone https://github.com/templ-project/cpp.git my-cpp-project",
        f"git clone <your-repo-url> {project_name}",
    )

    with open(readme_path, "w", encoding="utf-8") as f:
        f.write(content)

    print("  ✓ Updated README.md metadata")


def clone_template(target_path):
    """Clone the template repository to target directory."""
    print("📁 Cloning template repository...\n")

    # Ensure target directory exists
    target_path.mkdir(parents=True, exist_ok=True)

    # Check if directory is empty
    if any(target_path.iterdir()):
        print("Error: Target directory is not empty")
        print(f"   Directory: {target_path}")
        print("   Please use an empty directory or remove existing files.")
        sys.exit(1)

    try:
        # Clone the repository
        print("  Cloning from https://github.com/templ-project/cpp...")
        subprocess.run(
            [
                "git",
                "clone",
                "--depth",
                "1",
                "https://github.com/templ-project/cpp.git",
                str(target_path),
            ],
            check=True,
            capture_output=True,
        )
        print(f"  ✓ Template cloned to {target_path}")
    except subprocess.CalledProcessError as e:
        print("❌ Error: Failed to clone repository")
        print(f"   {e}")
        print("\nPlease ensure:")
        print("  1. Git is installed and available in PATH")
        print("  2. You have internet connectivity")
        print("  3. You have access to https://github.com/templ-project/cpp")
        sys.exit(1)


def bootstrap(target_path, project_name=None):
    """Main bootstrap function."""
    print("\n🚀 C++ Template Bootstrap\n")

    target_path = Path(target_path).resolve()

    # Extract project name from directory if not provided
    if project_name is None:
        project_name = extract_project_name(target_path)

    print(f"Project name: {project_name}")

    # Clone template repository to target directory
    clone_template(target_path)

    print("\n📦 Cleaning up template artifacts...\n")

    # Remove .git directory
    git_dir = target_path / ".git"
    remove_if_exists(git_dir)

    # Remove bootstrap script itself
    bootstrap_script = target_path / "bootstrap.py"
    remove_if_exists(bootstrap_script)

    # Remove _uvx_install directory
    install_dir = target_path / "_uvx_install"
    remove_if_exists(install_dir)

    # Remove legacy install directories if they exist
    old_install_dir = target_path / "_install"
    remove_if_exists(old_install_dir)
    legacy_install_dir = target_path / ".uvx-install"
    remove_if_exists(legacy_install_dir)

    # Remove pyproject.toml (bootstrap packaging file)
    pyproject_file = target_path / "pyproject.toml"
    remove_if_exists(pyproject_file)

    # Remove mise.lock file
    mise_lock = target_path / ".mise.lock"
    remove_if_exists(mise_lock)

    # Remove .cwai directory
    cwai_dir = target_path / ".cwai"
    remove_if_exists(cwai_dir)

    # Remove .github/prompts directory
    github_prompts_dir = target_path / ".github" / "prompts"
    remove_if_exists(github_prompts_dir)

    print(f"\n📝 Updating project metadata for '{project_name}'...\n")

    # Update project files with the project name
    update_cmake_metadata(target_path / "CMakeLists.txt", project_name)
    update_vcpkg_metadata(target_path / "vcpkg.json", project_name)
    update_xmake_metadata(target_path / "xmake.lua", project_name)
    update_taskfile_metadata(target_path / "Taskfile.yml", project_name)
    update_readme_metadata(target_path / "README.md", project_name)

    print("\n✨ Bootstrap complete!\n")
    print("Next steps:")
    print("  1. Install dependencies:")
    print("     # Using Conan")
    print("     conan install . --build=missing")
    print("     # OR using vcpkg")
    print("     vcpkg install")
    print("  2. Build the project:")
    print("     cmake -B build -DCMAKE_CXX_COMPILER=clang++")
    print("     cmake --build build --parallel")
    print("  3. Run tests:")
    print("     cd build && ctest")
    print("  4. Start coding!\n")


def main():
    """Entry point."""
    args = parse_args()
    bootstrap(args.path, args.project_name)


if __name__ == "__main__":
    main()
