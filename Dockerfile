# -------- Stage 1: Build --------
FROM python:3.11-alpine AS builder

WORKDIR /app

# Install build dependencies (only temporarily)
RUN apk add --no-cache build-base

COPY requirements.txt .

# Install dependencies into a custom folder
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


# -------- Stage 2: Runtime (very small) --------
FROM python:3.11-alpine

WORKDIR /app

# Copy only installed packages
COPY --from=builder /install /usr/local

# Copy app code
COPY . .

# Expose port
EXPOSE 8080

# Run app
CMD ["gunicorn", "-b", "0.0.0.0:8080", "app:app"]