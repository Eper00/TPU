# MLP modell
import torch
import torch.nn as nn
import gzip
import numpy as np
from torch.utils.data import Dataset

class MLP(nn.Module):
    def __init__(self):
        super(MLP, self).__init__()
        # Első rejtett réteg
        self.fc1 = nn.Linear(28 * 28, 128)
        # Második rejtett réteg
        self.fc2 = nn.Linear(128, 64)
        # Kimeneti réteg
        self.fc3 = nn.Linear(64, 10)

    def forward(self, x):
        x = x.view(-1, 28 * 28)  # Flatten a képeket (28x28 -> 784)
        x = torch.relu(self.fc1(x))  # Első rejtett réteg
        x = torch.relu(self.fc2(x))  # Második rejtett réteg
        x = self.fc3(x)  # Kimeneti réteg
        return x
# MNIST adat osztály létrehozása
class MNISTDataset(Dataset):
    def __init__(self, images_path, labels_path, transform=None):
        self.images_path = images_path
        self.labels_path = labels_path
        self.transform = transform

        # Képek és címkék beolvasása
        self.images = self.read_images(images_path)
        self.labels = self.read_labels(labels_path)
    
    def __len__(self):
        return len(self.labels)

    def __getitem__(self, idx):
        image = self.images[idx]
        label = self.labels[idx]

        if self.transform:
            image = self.transform(image)
        
        return torch.tensor(image, dtype=torch.float32).unsqueeze(0), label

    def read_images(self, path):
        with gzip.open(path, 'rb') as f:
            f.read(16)  # Első 16 bájt elhagyása
            images = np.frombuffer(f.read(), dtype=np.uint8)
            return images.reshape(-1, 28, 28) / 255.0  # Normalizálás 0-1 közé
    
    def read_labels(self, path):
        with gzip.open(path, 'rb') as f:
            f.read(8)  # Első 8 bájt elhagyása
            labels = np.frombuffer(f.read(), dtype=np.uint8)
            return labels