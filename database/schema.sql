-- InsuGuia Mobile - Database Schema
-- PostgreSQL Database Setup

-- Create database (execute as postgres superuser)
-- CREATE DATABASE insuguia_mobile;

-- Connect to insuguia_mobile database and run the following:

-- Enum for gender
CREATE TYPE gender_enum AS ENUM ('M', 'F');

-- Table: paciente
CREATE TABLE paciente (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    sexo gender_enum NOT NULL,
    data_nascimento DATE NOT NULL,
    peso DECIMAL(5,2) NOT NULL, -- kg, ex: 75.50
    altura DECIMAL(5,2) NOT NULL, -- cm, ex: 175.00
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: acompanhamento_diario
CREATE TABLE acompanhamento_diario (
    id SERIAL PRIMARY KEY,
    paciente_id INTEGER NOT NULL REFERENCES paciente(id) ON DELETE CASCADE,
    data_acompanhamento DATE NOT NULL,
    creatinina DECIMAL(5,2) NOT NULL, -- mg/dL, ex: 1.20
    peso DECIMAL(5,2) NOT NULL, -- kg, pode ser diferente do peso inicial
    nivel_glicose INTEGER NOT NULL, -- mg/dL, ex: 180
    prescricao_gerada TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for better performance
CREATE INDEX idx_paciente_nome ON paciente(nome);
CREATE INDEX idx_acompanhamento_paciente_id ON acompanhamento_diario(paciente_id);
CREATE INDEX idx_acompanhamento_data ON acompanhamento_diario(data_acompanhamento);

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to automatically update updated_at
CREATE TRIGGER update_paciente_updated_at 
    BEFORE UPDATE ON paciente 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Sample data for testing (optional)
-- INSERT INTO paciente (nome, sexo, data_nascimento, peso, altura) VALUES
-- ('João Silva', 'M', '1985-06-15', 75.5, 175.0),
-- ('Maria Santos', 'F', '1978-03-22', 68.0, 162.0);