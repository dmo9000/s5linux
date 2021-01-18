
echo "+++ build validator: [$0] [$*]"
set -x
set -e
bash -n $0 $* || exit 1
set +e
set +x

