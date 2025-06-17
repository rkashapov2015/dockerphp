#!/bin/bash

if [ ! -f .env ]; then
    echo "❌ Файл .env не найден!"
    echo "👉 Скопируйте шаблон:"
    echo "   cp .env.example .env"
    exit 1
else
    echo "✅ Файл .env найден."
fi