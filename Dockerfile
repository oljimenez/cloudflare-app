################################################################################
# BUILDER
################################################################################
FROM node:18-alpine as builder

WORKDIR /app

COPY ./package.json .
COPY ./yarn.lock .

RUN --mount=type=secret,id=npmrc,target=/app/.npmrc \
  if [ -f yarn.lock ]; then yarn install; \
  else echo "Lockfile not found." && exit 1; \
  fi

################################################################################
# RUNNER
################################################################################
FROM node:18-alpine as runner

WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY . .
