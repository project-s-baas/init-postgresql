FROM postgres:16

# 필요한 확장 설치
RUN apt-get update && apt-get install -y postgresql-contrib

# 초기화 SQL 파일 복사 (여기서 환경 변수를 사용 가능)
COPY init.sql /docker-entrypoint-initdb.d/