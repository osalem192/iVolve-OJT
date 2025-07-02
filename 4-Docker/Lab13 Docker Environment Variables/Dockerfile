# Use python base image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy files
COPY . .

# Install Flask
RUN pip install flask

# Expose the application port
EXPOSE 8080

# Set default environment variables
ENV APP_MODE=production
ENV APP_REGION=canada-west

# Run the application
CMD ["python", "app.py"]
