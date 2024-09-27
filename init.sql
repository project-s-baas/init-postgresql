-- 필요한 확장 설치
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "vector";


-- 예시 테이블 생성
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    email VARCHAR(100) UNIQUE NOT NULL,
    username VARCHAR(100) DEFAULT 'Anonymous',
    avatar TEXT
);

CREATE TABLE IF NOT EXISTS config (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    database JSON NOT NULL,
    setting JSON NOT NULL
);

CREATE TABLE IF NOT EXISTS posts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    title VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE
);

-- pgvector를 사용하는 테이블 예시 (벡터 크기를 3으로 가정)
CREATE TABLE IF NOT EXISTS embeddings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    embedding vector(3),  -- 3차원 벡터
    user_id UUID REFERENCES users(id) ON DELETE CASCADE
);

INSERT INTO config (database, setting) VALUES (
    '[
        {
            "visible": true, 
            "name": "users", 
            "description": "유저 기본 테이블",
            "schema": [
                {"name": "id", "type": "UUID", "primary": true, "unique": false, "notnull": false, "default": "uuid_generate_v4()"},
                {"name": "created_at", "type": "TIMESTAMP", "primary": false, "unique": false, "notnull": false, "default": "CURRENT_TIMESTAMP"},
                {"name": "updated_at", "type": "TIMESTAMP", "primary": false, "unique": false, "notnull": false, "default": "CURRENT_TIMESTAMP"},
                {"name": "email", "type": "VARCHAR(100)", "primary": false, "unique": true, "notnull": true},
                {"name": "username", "type": "VARCHAR(100)", "primary": false, "unique": false, "notnull": false, "default": "Anonymous"},
                {"name": "avatar", "type": "TEXT", "primary": false, "unique": false, "notnull": false}
            ]
        },
        {
            "visible": false, 
            "name": "config", 
            "description": "환경설정 기본 테이블",
            "schema": [
                {"name": "id", "type": "UUID", "primary": true, "unique": false, "notnull": false, "default": "uuid_generate_v4()"},
                {"name": "created_at", "type": "TIMESTAMP", "primary": false, "unique": false, "notnull": false, "default": "CURRENT_TIMESTAMP"},
                {"name": "database", "type": "JSON", "primary": false, "unique": false, "notnull": true},
                {"name": "setting", "type": "JSON", "primary": false, "unique": false, "notnull": true}
            ]
        },
        {
            "visible": true, 
            "name": "posts", 
            "description": "환경설정 기본 테이블",
            "schema": [
                {"name": "id", "type": "UUID", "primary": true, "unique": false, "notnull": false, "default": "uuid_generate_v4()"},
                {"name": "created_at", "type": "TIMESTAMP", "primary": false, "unique": false, "notnull": false, "default": "CURRENT_TIMESTAMP"},
                {"name": "updated_at", "type": "TIMESTAMP", "primary": false, "unique": false, "notnull": false, "default": "CURRENT_TIMESTAMP"},
                {"name": "title", "type": "VARCHAR(100)", "primary": false, "unique": false, "notnull": true},
                {"name": "content", "type": "TEXT", "primary": false, "unique": false, "notnull": true},
                {"name": "user_id", "type": "UUID", "primary": false, "unique": false, "notnull": true, "reference": "users(id)"}
            ]
        }
    ]', '[]');

INSERT INTO users (email, username) VALUES ('test@test.com', '아무개123');

INSERT INTO posts (title, content, user_id) VALUES ('테스트 제목', '테스트 내용', (SELECT id FROM users WHERE email = 'test@test.com'));

INSERT INTO embeddings (embedding, user_id) VALUES ('[0.1, 0.2, 0.3]', (SELECT id FROM users WHERE email = 'test@test.com'));


-- 다른 필요한 테이블이나 설정 추가