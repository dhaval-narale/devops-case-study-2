FROM bitnami/node:18
WORKDIR /app
COPY src/ .
RUN npm init -y
EXPOSE 3000
CMD ["node", "index.js"]
