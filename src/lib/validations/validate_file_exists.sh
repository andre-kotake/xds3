## [@bashly-upgrade validations]
validate_file_exists() {
	[[ -z $1 ]] && echo "must not be empty"
	[[ -f $1 ]] || echo "must be an existing file"
}
