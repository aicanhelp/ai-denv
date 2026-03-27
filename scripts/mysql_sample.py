import base64
import pymysql
from pymysql.err import OperationalError, ProgrammingError

# -------------------------- 配置项（请根据实际情况修改） --------------------------
MYSQL_CONFIG = {
    "host": "localhost",       # MySQL主机地址
    "port": 3306,              # MySQL端口
    "user": "root",            # MySQL用户名
    "password": "12345",     # MySQL密码
    "charset": "utf8mb4"       # 字符集（避免中文乱码）
}
DB_NAME_PATTERN = "prefix_%"  # 数据库名匹配样式（MySQL通配符，%表示任意字符）
# ---------------------------------------------------------------------------------

def get_base64_encoded(value):
    """
    对任意类型的值做base64编码
    :param value: 待编码的值（支持字符串、数字、None等）
    :return: base64编码后的字符串
    """
    # 处理None值
    if value is None:
        return base64.b64encode(b"NULL").decode("utf-8")
    # 统一转换为字符串，再转字节码编码
    try:
        str_value = str(value)
        encoded = base64.b64encode(str_value.encode("utf-8")).decode("utf-8")
        return encoded
    except Exception as e:
        return f"编码失败: {str(e)}"

def main():
    # 1. 连接MySQL，获取符合样式的数据库列表
    try:
        # 先连接MySQL（不指定具体数据库）
        conn = pymysql.connect(**MYSQL_CONFIG)
        cursor = conn.cursor()

        # 查询符合样式的数据库名
        cursor.execute(f"SHOW DATABASES LIKE '{DB_NAME_PATTERN}'")
        databases = [db[0] for db in cursor.fetchall()]
        if not databases:
            print(f"未找到匹配 '{DB_NAME_PATTERN}' 的数据库")
            return

        # 2. 遍历每个数据库
        for db_name in databases:
            print(f"\n==================== 数据库: {db_name} ====================")
            # 切换到当前数据库
            cursor.execute(f"USE {db_name}")

            # 3. 获取当前数据库的所有表名
            cursor.execute("SHOW TABLES")
            tables = [table[0] for table in cursor.fetchall()]
            if not tables:
                print(f"数据库 {db_name} 中无表")
                continue

            # 4. 遍历每个表
            for table_name in tables:
                print(f"\n---------- 表: {table_name} ----------")
                try:
                    # 获取表的字段名和第一行数据
                    cursor.execute(f"SELECT * FROM {table_name} LIMIT 1")
                    # 获取字段名（游标描述）
                    fields = [desc[0] for desc in cursor.description]
                    # 获取第一行数据
                    first_row = cursor.fetchone()

                    if first_row is None:
                        print(f"表 {table_name} 无数据")
                        continue

                    # 5. 遍历字段和值，做base64编码并输出
                    print("字段名 | 原始值 | base64编码值")
                    print("-" * 50)
                    for field, value in zip(fields, first_row):
                        encoded_value = get_base64_encoded(value)
                        print(f"{field} | {value} | {encoded_value}")

                except ProgrammingError as e:
                    print(f"访问表 {table_name} 失败: {e}")
                    continue

    except OperationalError as e:
        print(f"MySQL连接失败: {e}")
        return
    finally:
        # 关闭游标和连接
        if 'cursor' in locals() and cursor:
            cursor.close()
        if 'conn' in locals() and conn:
            conn.close()

if __name__ == "__main__":
    main()