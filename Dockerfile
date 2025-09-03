# Use official Node.js LTS base image
FROM node:18

# Set working directory inside container
WORKDIR /app

# Copy package.json and package-lock.json first (for caching npm install)
COPY src/package*.json ./

# Install app dependencies
RUN npm install

# Copy app source code
COPY src/ .

# Expose port 3000 for the app
EXPOSE 3000

# Command to run the app
CMD ["node", "index.js"]
