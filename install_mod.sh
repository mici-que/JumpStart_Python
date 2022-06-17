#!/bin/bash
cd ..
[[ -z "$1" ]] && { echo 'No package name is given.'; exit 1; }
packagename="$1"

username="mici-que"

# --- Create folder and repo ---

mkdir "$packagename"

cd "$packagename"

git init
gh repo create -y --public git@github.com:"$username"/"$packagename".git

# --- Create git actions ---
mkdir .github
mkdir .github/workflows
mkdir .vscode

cd ..

# -----------------------------
# --- Fetch Resources
# -----------------------------

#requirements.txt
cp JumpStart/resource/requirements.txt "$packagename"
# NOTES.md
cp JumpStart/resource/NOTES.md "$packagename"
#.gitignore
cp JumpStart/resource/.gitignore "$packagename"
# tox.ini
cp JumpStart/resource/tox.ini "$packagename"
# pytest.ini
cp JumpStart/resource/pytest.ini "$packagename"
#git action from template
cp JumpStart/resource/lint_and_test.yml "$packagename"/.github/workflows
# vscode settings
cp JumpStart/resource/.vscode/*.* "$packagename"/.vscode

cd "$packagename"

# -----------------------------
# --- Generate source files ---
# -----------------------------

cat > "$packagename".py <<EOL
def main():
  pass
EOL

cat > test_"$packagename".py <<EOL
from ${packagename} import main
# initial test
def test_init():
    assert(main())==False
EOL

cat > README.md <<EOL
# Exercise: ${packagename}

[![LintAndTest](https://github.com/$username/${packagename}/actions/workflows/lint_and_test.yml/badge.svg)](https://github.com/$username/${packagename}/actions/workflows/lint_and_test.yml)

EOL

cat > TechDebt.md <<EOL
# Technical debt
EOL

cat > sonar-project.properties <<EOL
sonar.projectKey=$username_$packagename
sonar.organization=$username
 
sonar.python.coverage.reportPaths=coverage.xml

EOL

git add .

git commit -m "initialized repo"

git branch -M main

git remote add origin https://github.com/"$username"/"$packagename".git

git push --set-upstream origin main


# create and start venv

#make venv
python -m venv ./venv
#activate venv
cd venv
cd Scripts
. activate
cd ..
cd ..
#update pip
py -m pip install --upgrade pip
#install dependencies from requirements.txt to venv
pip install -r requirements.txt
#deactivate venv
deactivate

# open vscode
code .

Set-ExecutionPolicy Unrestricted -Scope Process
.\venv\Scripts\Activate.ps1