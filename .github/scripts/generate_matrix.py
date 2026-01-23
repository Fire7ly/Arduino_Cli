import json
import os
import sys

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

    if not targets:
        # Fallback for old schema
        board = config.get('board')
        if board:
            version = config.get('board_version', 'latest')
            targets = [{'board': board, 'versions': [version]}]
            artifact_prefix = config.get('artifact_name', 'Arduino-Binary')

    matrix_include = []

    for target in targets:
        board = target.get('board')
        versions = target.get('versions', ['latest'])
        
        for version in versions:
            artifact_name = f"{artifact_prefix}-{board}-{version}"
            matrix_include.append({
                'board': board,
                'version': version,
                'artifact_name': artifact_name,
                'retention_days': retention_days,
                'sketch_path': sketch_path
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
