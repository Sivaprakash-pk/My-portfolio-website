# Use the official Nginx image
FROM nginx:latest

# Remove the default Nginx welcome page
RUN rm -rf /usr/share/nginx/html/*

# Clone the GitHub repository into the container
RUN apt-get update && apt-get install -y git
RUN git clone https://github.com/Sivaprakash-pk/My-portfolio-website.git /usr/share/nginx/html

# Expose port 80 for Nginx
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
