#!/bin/bash

# -------------------------- 配置项（请根据实际情况修改） --------------------------
MYSQL_HOST="0.0.0.0"       # MySQL主机地址
MYSQL_PORT="3306"            # MySQL端口
MYSQL_USER="root"            # MySQL用户名
MYSQL_PASSWORD="123456"      # MySQL密码
DB_NAME_PATTERN="jt_%"      # 数据库名匹配样式（MySQL通配符，%表示任意字符）
# ---------------------------------------------------------------------------------

# 定义Base64编码函数（兼容空值、特殊字符）
base64_encode() {
    local value="$1"
    # 处理空值（NULL）
    if [ -z "$value" ] || [ "$value" = "NULL" ]; then
        echo -n "NULL" | base64
        return
    fi
    # 处理普通值（避免换行符干扰，用-n取消echo默认换行）
    echo -n "$value" | base64
}

csv_field() {
    local field="$1"
    field="${field//\"/\"\"}"
    echo "\"${field}\""
}

# 检查mysql命令是否存在
if ! command -v mysql &> /dev/null; then
    echo "错误：未找到mysql命令行工具，请先安装MySQL客户端！"
    exit 1
fi

export MYSQL_PWD=${MYSQL_PASSWORD}
# 构建mysql连接命令（避免密码明文显示在进程列表，用--defaults-extra-file更安全，这里简化用-p）
#MYSQL_CMD="mysql -h${MYSQL_HOST} -P${MYSQL_PORT} -u${MYSQL_USER} -p${MYSQL_PASSWORD} -N -s -e"
MYSQL_CMD="mysql -h${MYSQL_HOST} -P${MYSQL_PORT} -u${MYSQL_USER} -N -s -e"
# -N：不显示列名；-s：静默模式，减少冗余输出；-e：执行SQL语句

# 1. 获取符合样式的所有数据库名
#echo "正在查询匹配 '${DB_NAME_PATTERN}' 的数据库..."
DATABASES=$(${MYSQL_CMD} "SHOW DATABASES LIKE '${DB_NAME_PATTERN}'")

if [ -z "$DATABASES" ]; then
    echo "未找到匹配 '${DB_NAME_PATTERN}' 的数据库！"
    exit 0
fi

# 2. 遍历每个数据库
for DB_NAME in $DATABASES; do
#    echo -e "\n==================== 数据库: ${DB_NAME} ===================="

    # 3. 获取当前数据库的所有表名
    TABLES=$(${MYSQL_CMD} "USE ${DB_NAME}; SHOW TABLES")

    if [ -z "$TABLES" ]; then
#        echo "数据库 ${DB_NAME} 中无表！"
        continue
    fi

    # 4. 遍历每个表
    for TABLE_NAME in $TABLES; do
#        echo -e "\n---------- 表: ${TABLE_NAME} ----------"

        # 5. 获取表的字段名（用INFORMATION_SCHEMA更可靠）
        FIELDS=$(${MYSQL_CMD} "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA='${DB_NAME}' AND TABLE_NAME='${TABLE_NAME}' ORDER BY ORDINAL_POSITION")

        # 6. 获取表的第一行数据（保留原始分隔符，用|分割字段值）
        # 设置mysql输出字段分隔符为|，避免空格/制表符干扰

        FIRST_ROW=$(${MYSQL_CMD} "USE ${DB_NAME}; SET SESSION group_concat_max_len = 1024000; SELECT * FROM ${TABLE_NAME} LIMIT 1" -B | \
  awk -F'\t' '{
    result=""
    for(i=1; i<=NF; i++) {
      gsub(/\|/, "\\|", $i)  # 先转义字段内的 |
      if(i==1) result=$i
      else result=result "|" $i
    }
    print result
  }')
        # 处理空表情况
        if [ -z "$FIRST_ROW" ] || [ "$FIRST_ROW" = "NULL" ]; then
#            echo "表 ${TABLE_NAME} 无数据！"
            continue
        fi

#        # 7. 拆分字段名和值，逐行编码输出
#        echo "字段名 | 原始值 | Base64编码值"
#        echo "--------------------------------------------------"

        # 将字段名和值转为数组（兼容空格）
        IFS=$'\n' read -r -d '' -a FIELD_ARRAY <<< "$FIELDS"
        IFS='|' read -r -a VALUE_ARRAY <<< "$FIRST_ROW"

        # 遍历字段和值，编码并输出
        for i in "${!FIELD_ARRAY[@]}"; do
            FIELD="${FIELD_ARRAY[$i]}"
            VALUE="${VALUE_ARRAY[$i]}"
            # 处理数组索引越界（字段数和值数不匹配）
            if [ -z "$VALUE" ]; then
                ENCODED_VALUE=""
            else
                ENCODED_VALUE=$(base64_encode "$VALUE")
            fi

            echo "${DB_NAME},${TABLE_NAME},${FIELD},$(csv_field "${VALUE}"),$(csv_field "${ENCODED_VALUE}")"
        done
    done
done

#echo -e "\n==================== 执行完成 ===================="