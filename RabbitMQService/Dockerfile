FROM rabbitmq:3.9.5

# Expose the necessary ports
EXPOSE 5672 15672

# Copy custom configuration file
#COPY rabbitmq.conf /etc/rabbitmq/

# Enable the required RabbitMQ plugins
RUN rabbitmq-plugins enable --offline rabbitmq_management

# Set the default username and password
ENV RABBITMQ_DEFAULT_USER=admin
ENV RABBITMQ_DEFAULT_PASS=password
