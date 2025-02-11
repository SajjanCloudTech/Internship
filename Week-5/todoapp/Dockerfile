# Stage 1: Build the application
FROM node:23-alpine3.20 AS builder
 
WORKDIR /app
 
COPY package*.json ./
 
RUN npm install
 
COPY . .
 
# Stage 2: Create the production image
FROM node:23-alpine3.20
 
WORKDIR /app
 
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
 
COPY --from=builder /app ./
 
RUN mkdir -p /app/data && chown -R node:node /app && chmod -R 755 /app
 
EXPOSE 3000
 
USER node
 
CMD ["npm", "start"]