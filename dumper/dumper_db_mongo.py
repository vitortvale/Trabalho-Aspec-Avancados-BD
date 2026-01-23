from pymongo import MongoClient
from bson.json_util import dumps # Serializador específico para tipos do MongoDB

def backup_python_puro(uri, db_name, output_file):
    """
    Exporta dados do MongoDB para JSON preservando tipos (ObjectId, ISODate).
    """
    client = MongoClient(uri)
    db = client[db_name]
    
    backup_data = {}
    
    # Itera sobre todas as coleções
    for collection_name in db.list_collection_names():
        print(f"Exportando coleção: {collection_name}")
        # Converte o cursor para lista
        data = list(db[collection_name].find())
        backup_data[collection_name] = data
        
    # Salva usando dumps do bson.json_util
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(dumps(backup_data, indent=2))

if __name__ == "__main__":
    # Exemplo de uso
    URI = "mongodb+srv://aabd:aabd@cluster0.jqosrul.mongodb.net/?appName=Cluster0"
    BANCO = "test"
    ARQUIVO = "dumpmonfodb.json"
    
    print(f"Iniciando exportação de {BANCO}...")
    backup_python_puro(URI, BANCO, ARQUIVO)
    print(f"Exportação concluída em {ARQUIVO}")