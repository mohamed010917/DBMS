
validate_value() {
    local type="$1"
    local value="$2"

    case "$type" in
        int)
            [[ "$value" =~ ^-?[0-9]+$ ]]
        ;;

        float)
            [[ "$value" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]
        ;;

        string)
            [[ -n "$value" ]]
        ;;

        bool)
            [[ "$value" =~ ^(true|false|0|1)$ ]]
        ;;

        date)
            [[ "$value" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]
        ;;

        *)
            echo "Unknown type: $type"
            return 1
        ;;
    esac
}
