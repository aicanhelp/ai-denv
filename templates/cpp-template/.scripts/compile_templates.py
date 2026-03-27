#!/usr/bin/env python3
"""
Template Compiler Script

Renders Jinja2 templates for build system configuration files based on
environment variables from .mise.toml flags.

Usage:
    python scripts/compile_templates.py --build-system cmake
    python scripts/compile_templates.py --build-system xmake
    python scripts/compile_templates.py --build-system bazel
"""

import argparse
import io
import os
import platform
import sys
from pathlib import Path

# Ensure stdout/stderr use UTF-8 encoding on Windows
if sys.platform == "win32":
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding="utf-8", errors="replace")

try:
    from jinja2 import Environment, FileSystemLoader, StrictUndefined
except ImportError:
    print("❌ Error: jinja2 is not installed.", file=sys.stderr)
    print("Install it with: uv pip install jinja2", file=sys.stderr)
    sys.exit(1)


def get_template_context():
    """Extract configuration from environment variables set by .mise.toml"""
    compiler = os.getenv("CPP_COMPILER", "clang++")
    target_arch = os.getenv("CPP_TARGET_ARCH", "")

    return {
        "build_system": os.getenv("CPP_BUILD_SYSTEM", "cmake"),
        "build_type": os.getenv("CPP_BUILD_TYPE", "Release"),
        "build_dir": os.getenv("CPP_BUILD_DIR", "build"),
        "compiler": compiler,
        "project_name": os.getenv("CPP_PROJECT_NAME", "cpp-template"),
        "target_arch": target_arch,
        "os": lambda: platform.system().lower(),  # Add os() function for templates
        "os_env": os.getenv,
    }


def compile_template(template_name: str, output_path: Path, context: dict) -> None:
    """Render a Jinja2 template and write to output path"""
    project_root = Path(__file__).parent.parent
    templates_dir = project_root / "templates"

    if not templates_dir.exists():
        print(
            f"❌ Error: Templates directory not found at {templates_dir}",
            file=sys.stderr,
        )
        sys.exit(1)

    # Setup Jinja2 environment
    env = Environment(
        loader=FileSystemLoader(templates_dir),
        undefined=StrictUndefined,
        trim_blocks=True,
        lstrip_blocks=True,
    )

    try:
        template = env.get_template(template_name)
        rendered = template.render(**context)

        # Ensure trailing newline for POSIX compliance
        if not rendered.endswith("\n"):
            rendered += "\n"

        # Ensure output directory exists
        output_path.parent.mkdir(parents=True, exist_ok=True)

        # Write rendered template
        output_path.write_text(rendered)
        print(f"✓ Generated: {output_path.relative_to(project_root)}")

    except (FileNotFoundError, PermissionError, OSError) as e:
        print(f"❌ Error rendering {template_name}: {e}", file=sys.stderr)
        sys.exit(1)


def compile_cmake_templates(context: dict) -> None:
    """Compile CMake configuration files"""
    project_root = Path(__file__).parent.parent
    compile_template("CMakeLists.txt.j2", project_root / "CMakeLists.txt", context)
    compile_template(
        "src_CMakeLists.txt.j2", project_root / "src" / "CMakeLists.txt", context
    )


def compile_xmake_templates(context: dict) -> None:
    """Compile XMake configuration files"""
    project_root = Path(__file__).parent.parent
    compile_template("xmake.lua.j2", project_root / "xmake.lua", context)


def compile_bazel_templates(context: dict) -> None:
    """Compile Bazel configuration files"""
    project_root = Path(__file__).parent.parent
    compile_template("BUILD.bazel.j2", project_root / "BUILD.bazel", context)
    compile_template(
        "tests_BUILD.bazel.j2", project_root / "tests" / "BUILD.bazel", context
    )
    compile_template(".bazelrc.j2", project_root / ".bazelrc", context)
    compile_template("MODULE.bazel.j2", project_root / "MODULE.bazel", context)
    compile_template("WORKSPACE.j2", project_root / "WORKSPACE", context)


def main():
    """Main entry point for template compilation."""
    parser = argparse.ArgumentParser(
        description="Compile Jinja2 templates for build system configuration"
    )
    parser.add_argument(
        "--build-system",
        choices=["cmake", "xmake", "bazel"],
        required=True,
        help="Build system to generate configuration for",
    )
    parser.add_argument(
        "--compiler",
        help="C++ compiler path (overrides CPP_COMPILER env var)",
    )
    parser.add_argument(
        "--arch",
        choices=["x86_64", "aarch64", "arm64", ""],
        default="",
        help="Target architecture (x86_64, aarch64/arm64)",
    )

    args = parser.parse_args()

    # Get context from environment
    context = get_template_context()

    # Override compiler if provided via CLI
    if args.compiler:
        context["compiler"] = args.compiler

    # Override arch if provided via CLI
    if args.arch:
        # Normalize arm64 to aarch64
        context["target_arch"] = "aarch64" if args.arch == "arm64" else args.arch

    print(f"📝 Compiling templates for {args.build_system}...")
    print(f"   Project: {context['project_name']}")
    print(f"   Build Type: {context['build_type']}")
    print(f"   Build Dir: {context['build_dir']}")
    print(f"   Compiler: {context['compiler']}")
    if context["target_arch"]:
        print(f"   Target Arch: {context['target_arch']}")
    print()

    # Compile templates based on build system
    if args.build_system == "cmake":
        compile_cmake_templates(context)
    elif args.build_system == "xmake":
        compile_xmake_templates(context)
    elif args.build_system == "bazel":
        compile_bazel_templates(context)

    print()
    print(f"✓ Template compilation complete for {args.build_system}")


if __name__ == "__main__":
    main()
