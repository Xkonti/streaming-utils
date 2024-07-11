# Build stage
FROM oven/bun:latest as builder

# Set working directory
WORKDIR /app

# Copy package.json and bun.lockb (if it exists)
COPY package.json bun.lockb* ./

# Install dependencies
RUN bun install

# Copy the rest of the project files
COPY . .

# Build the project
RUN bun run build

# Production stage
FROM oven/bun:slim

# Set working directory
WORKDIR /app

# Copy the built project from the builder stage
COPY --from=builder /app/.output .

# Expose port 3000
EXPOSE 3000

# Set the command to run the server
CMD ["bun", "run", "./server/index.mjs"]