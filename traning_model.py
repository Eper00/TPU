import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import  DataLoader
from model import MLP,MNISTDataset
import os
import urllib.request

# MNIST adat letöltése és kibővítése
def download_mnist():
    if not os.path.exists('mnist'):
        os.makedirs('mnist')

    # Letöltési URL-ek
    url_train_images = "https://storage.googleapis.com/cvdf-datasets/mnist/train-images-idx3-ubyte.gz"
    url_train_labels = "https://storage.googleapis.com/cvdf-datasets/mnist/train-labels-idx1-ubyte.gz"
  

    # Letöltés
    urllib.request.urlretrieve(url_train_images, 'mnist/train-images-idx3-ubyte.gz')
    urllib.request.urlretrieve(url_train_labels, 'mnist/train-labels-idx1-ubyte.gz')




# Előfeldolgozó függvény (ha szükséges)
def transform(image):
    return image

# Betöltés és előkészítés
download_mnist()

train_data = MNISTDataset('mnist/train-images-idx3-ubyte.gz', 'mnist/train-labels-idx1-ubyte.gz', transform=transform)
train_loader = DataLoader(train_data, batch_size=64, shuffle=True)




model = MLP()
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(model.parameters(), lr=0.001)

# Modell tanítása
epochs = 10
for epoch in range(epochs):
    model.train()
    running_loss = 0.0
    for images, labels in train_loader:
        optimizer.zero_grad()

        outputs = model(images)
        loss = criterion(outputs, labels)
        loss.backward()
        optimizer.step()

        running_loss += loss.item()

    print(f"Epoch [{epoch+1}/{epochs}], Loss: {running_loss / len(train_loader):.4f}")


torch.save(model.state_dict(), 'mnist_mlp.pt')
print("Modell mentve!")