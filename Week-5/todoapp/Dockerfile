# Stage 1: Build the application
FROM public.ecr.aws/docker/library/node:23-alpine AS builder
 
WORKDIR /app
 
COPY package*.json ./
 
RUN npm install
 
COPY . .
 
# Stage 2: Create the production image
FROM public.ecr.aws/docker/library/node:23-alpine
 
WORKDIR /app
 
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
 
COPY --from=builder /app ./
 
RUN mkdir -p /app/data && chown -R node:node /app && chmod -R 755 /app
 
EXPOSE 3000
 
USER node
 
CMD ["npm", "start"]