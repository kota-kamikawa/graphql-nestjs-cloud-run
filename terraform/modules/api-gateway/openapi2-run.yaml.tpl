swagger: '2.0'
info:
  title: GraphQL Service
  description: GraphQL API
  version: 1.0.0
host: ${cloud_run_graphql_domain} # ここにCloud RunサービスのURLを設定します
schemes:
  - https
paths:
  /graphql:
    post:
      summary: GraphQL Endpoint
      operationId: graphqlQuery
      consumes:
        - application/json
      produces:
        - application/json
      parameters:
        - in: body
          name: body
          description: GraphQL query
          required: true
          schema:
            type: object
            required:
              - query
            properties:
              query:
                type: string
              variables:
                type: object
      responses:
        '200':
          description: A successful GraphQL response
          schema:
            type: object
            properties:
              data:
                type: object
x-google-backend:
  address: https://${cloud_run_graphql_domain}/graphql # ここにCloud RunのGraphQLサービスのURLを設定します
  jwt_audience: ${cloud_run_graphql_domain}
