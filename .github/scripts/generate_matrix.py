import json
import os
import sys
import subprocess

def main():
    try:
        with open('build.config.json', 'r') as f:
            config = json.load(f)
    except FileNotFoundError:
        print("Error: build.config.json not found", file=sys.stderr)
        sys.exit(1)
    except json.JSONDecodeError:
        print("Error: Invalid JSON in build.config.json", file=sys.stderr)
        sys.exit(1)

    targets = config.get('targets', [])
    artifact_prefix = config.get('artifact_prefix', 'Arduino-Binary')
    retention_days = config.get('retention_days', 30)
    sketch_path = config.get('sketch_path', '.')

    build_settings = config.get('build_settings', {})
    version = build_settings.get('version', '0.0.1')
    release_enabled = str(build_settings.get('release_enabled', False)).lower()

    if not targets:
        # Fallback for old schema
        board = config.get('board')
        if board:
            version = config.get('board_version', 'latest')
            targets = [{'board': board, 'versions': [version]}]
            artifact_prefix = config.get('artifact_name', 'Arduino-Binary')

    # Get existing tags
    try:
        tags_output = subprocess.check_output(['git', 'tag', '-l'], text=True)
        existing_tags = set(tags_output.splitlines())
    except subprocess.CalledProcessError:
        existing_tags = set()

    def bump_version(v):
        parts = v.split('.')
        if len(parts) >= 3:
            try:
                parts[-1] = str(int(parts[-1]) + 1)
                return ".".join(parts)
            except ValueError:
                pass
        return v + ".1"

    matrix_include = []

    for target in targets:
        board = target.get('board')
        versions = target.get('versions', ['latest'])
        settings = target.get('settings', {})
        release_version = settings.get('version', '0.0.1')
        release_enabled = str(settings.get('release_enabled', False)).lower()
        
        # Auto-increment logic
        if release_enabled == 'true':
            full_tag = f"v{release_version}"
            while full_tag in existing_tags:
                print(f"Tag {full_tag} exists, bumping version...")
                release_version = bump_version(release_version)
                full_tag = f"v{release_version}"
        
        for v in versions:
            artifact_name = f"{artifact_prefix}-{board}-{v}"
            matrix_include.append({
                'board': board,
                'version': v,
                'artifact_name': artifact_name,
                'retention_days': retention_days,
                'sketch_path': sketch_path,
                'release_enabled': release_enabled,
                'release_version': release_version
            })

    output = {'include': matrix_include}
    json_output = json.dumps(output)
    
    # Write to GITHUB_OUTPUT if available, otherwise print
    github_output = os.environ.get('GITHUB_OUTPUT')
    if github_output:
        with open(github_output, 'a') as f:
            f.write(f"matrix={json_output}\n")
    else:
        print(json_output)

if __name__ == "__main__":
    main()
