#FROM python:3
#RUN pip install django==3.2

#COPY . .

#RUN python manage.py migrate
#EXPOSE 8000
#CMD ["python","manage.py","runserver","0.0.0.0:8000"]

FROM python:3

# Install distutils and other dependencies
RUN apt-get update && apt-get install -y python3-distutils

# Install Django
RUN pip install django==3.2

# Copy your project files
COPY . .

# Run migrations
RUN python manage.py migrate

# Expose port
EXPOSE 8000

# Command to run the app
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]


