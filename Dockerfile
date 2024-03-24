# syntax=docker/dockerfile:1
FROM node:18 AS builder
# ビルドには devDependencies もインストールする必要があるため
ENV NODE_ENV=development
WORKDIR /app
COPY package.json ./
COPY package-lock.json ./
COPY prisma ./prisma
RUN npm ci
RUN npm run prisma generate
COPY . .
RUN npm run build


FROM node:18-slim AS runner
ENV NODE_ENV=production

# マイグレーションで必要
RUN apt-get -qy update
RUN apt-get -qy install openssl

WORKDIR /app
COPY package.json ./
COPY package-lock.json ./
COPY prisma ./prisma
# NODE_ENV=productionにしてyarn install(npm install)するとdevDependenciesがインストールされません
RUN npm ci
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/prisma ./prisma
CMD ["npm", "run", "start:prod"]