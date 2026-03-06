cd micropython
git clean -dfx
git reset --hard
cd -

cd epdiy
git clean -dfx
git reset --hard
cd -

rm -rf ./build
rm -rf ./.cache
rm -rf ./__pycache__
