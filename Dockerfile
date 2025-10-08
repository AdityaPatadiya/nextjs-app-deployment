# Stage 1 - Dependencies (cached layer)
FROM node:18-alpine AS deps

WORKDIR /app

# Install OS dependencies
RUN apk add --no-cache libc6-compat

COPY package*.json ./

RUN npm ci



# Stage 2 - Builder (Build the next.js app)
FROM node:18-alpine AS builder

WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules

COPY . .

ENV NEXT_TELEMETRY_DISABLED=1

RUN npm run build



# Stage 3 - Runner (runtime image)
FROM node:18-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production

ENV NEXT_TELEMETRY_DISABLED=1

# create non-root user for better container security
RUN addgroup -g 1001 -S nodejs && adduser -S nextjs -u 1001

COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

EXPOSE 3000

USER nextjs
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s\
    CMD wget -qO- http://localhost:3000/ || exit 1

CMD ["npx", "next", "start", "-p", "3000", "-H", "0.0.0.0"]
