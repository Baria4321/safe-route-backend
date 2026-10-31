-- ============================================================
-- Safe Route App - Database Schema
-- Target: PostgreSQL with PostGIS extension (Supabase compatible)
-- ============================================================

-- 1. Enable PostGIS Extension
CREATE EXTENSION IF NOT EXISTS postgis;

-- 2. Places Table (OSM Help Points: Police, Hospitals, Pharmacies, Fuel, 24/7 Shops, ATMs)
CREATE TABLE IF NOT EXISTS places (
    id BIGSERIAL PRIMARY KEY,
    osm_id BIGINT UNIQUE NOT NULL,
    type VARCHAR(50) NOT NULL, -- 'police', 'hospital', 'pharmacy', 'fuel', 'shop24', 'atm'
    name VARCHAR(255),
    geom geography(Point, 4326) NOT NULL,
    opening_hours TEXT,
    is_24_7 BOOLEAN DEFAULT FALSE,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Spatial index on places geometry
CREATE INDEX IF NOT EXISTS idx_places_geom ON places USING GIST (geom);

-- Additional query indexes on places
CREATE INDEX IF NOT EXISTS idx_places_type ON places (type);
CREATE INDEX IF NOT EXISTS idx_places_is_24_7 ON places (is_24_7);

-- 3. Reports Table (Anonymous Community Safety Reports)
CREATE TABLE IF NOT EXISTS reports (
    id BIGSERIAL PRIMARY KEY,
    geom geography(Point, 4326) NOT NULL,
    type VARCHAR(50) NOT NULL, -- 'isolated', 'felt_unsafe', 'dark', 'harassment', 'safe_spot'
    note VARCHAR(200),
    status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'approved', 'rejected'
    ip_hash VARCHAR(64) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Spatial index on reports geometry
CREATE INDEX IF NOT EXISTS idx_reports_geom ON reports USING GIST (geom);

-- Status & spam prevention index
CREATE INDEX IF NOT EXISTS idx_reports_status ON reports (status);
CREATE INDEX IF NOT EXISTS idx_reports_ip_created ON reports (ip_hash, created_at);
