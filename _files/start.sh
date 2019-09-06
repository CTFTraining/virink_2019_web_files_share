#!/usr/bin/env sh

# Author : Virink <virink@outlook.com>
# Date   : 2019/09/06, 14:12

if [[ ! -f /f1ag_Is_h3re/flag ]]; then
    rm -rf /f1ag_Is_h3re
	mkdir -p /f1ag_Is_h3re
    echo $FLAG >> /f1ag_Is_h3re/flag
fi

export FLAG=not_flag
FLAG=not_flag

/usr/local/openresty/bin/openresty -g "daemon off;" 