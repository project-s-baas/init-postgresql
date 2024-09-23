-- 필요한 확장 설치
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 예시 테이블 생성
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    email VARCHAR(100) UNIQUE NOT NULL,
    username VARCHAR(100) DEFAULT 'Anonymous',
    avatar TEXT
);

-- 다른 필요한 테이블이나 설정 추가