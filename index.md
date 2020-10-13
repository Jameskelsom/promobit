# Processo Seletivo - Analista de BI

Testes com objetivo de avaliar a capacidade analítica e técnica do Analista de dados.
- CSV: https://drive.google.com/drive/folders/187B990VSdpVf1XcE_Wbyz17_FjygaqkU?usp=sharing

### Teste 1
Utilizar algum dataviz (Metabase, Tableau, PowerBI etc) para com o CSV enviado para fazer:
- Ranqueamento de reclamações
- Quais planos de saúde tiveram mais reclamações
- Quantidade de beneficiários dos planos com mais reclamações
- As datas mais recorrentes que aparecem nas reclamações

**Resultado em [POWER BI](https://app.powerbi.com/view?r=eyJrIjoiZmM5YTE3MjktZmRhYi00MzNjLWI3YjctZjA4Y2I2NjNhMzQxIiwidCI6IjJlNjAwMzY4LTk0YWQtNDA0YS1hMTM1LWQ3ODJlY2IwOTY4MiJ9)**

**![Image](https://media-private.canva.com/FSZB4/MAEKg4FSZB4/1/s2.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAQYCGKMUH4JWSMIDQ%2F20201013%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20201013T133616Z&X-Amz-Expires=32940&X-Amz-Signature=1800120b466aec964c52795d888d62352cea5658e4869b04a716ea0671749154&X-Amz-SignedHeaders=host&response-expires=Tue%2C%2013%20Oct%202020%2022%3A45%3A16%20GMT)**

### Teste 2
Fazer a mesma coisa, mas agora com um notebook python
Utilizar o estilo de gráfico que faça mais sentido com os dados apresentados.

```markdown
- Resultado:
import pandas as pd
import plotly.express as px

#ler arquivo csv
df = pd.read_csv('dados-gerais-das-reclamacoes-por-operadora.csv',sep=';',encoding='ISO-8859-1') 
#colunas do arquivo
col = df.columns
#agregando colunas e reset do index
rank = df.groupby(col[7]).agg({col[4]:'count'}).reset_index()
plano = df.groupby(col[1]).agg({col[4]:'count'}).reset_index().sort_values(col[4],ascending=False).head(10)
beneficiario = df.groupby(df[col[1]].str[:20])[col[2]].nunique().reset_index().sort_values(col[2],ascending=False)
dt_recorrente = df.groupby(pd.to_datetime(df[col[4]]).dt.strftime('%d/%m/%Y')).agg({col[0]:'count'}).reset_index().sort_values(col[0],ascending=False).head(10)

#renomear a coluna 
rank.rename(columns={'Data Atendimento': 'qtdReclamacoes','Subtema Demanda':'Subtema'}, inplace=True)
plano.rename(columns={'Data Atendimento': 'qtdReclamacoes','Razão Social': 'Planos'}, inplace=True)
beneficiario.rename(columns={'Razão Social': 'Planos'}, inplace=True)
dt_recorrente.rename(columns={'Registro ANS': 'qtdReclamacoes'}, inplace=True)
#criando o ranking
rank['Ranking'] = rank['qtdReclamacoes'].rank(ascending= False)
#order by Ranking
rank = rank.sort_values(by='Ranking',ascending= True).reset_index(drop=True)
plano = plano.sort_values(by='qtdReclamacoes',ascending= False).reset_index(drop=True)
beneficiario = beneficiario.sort_values(by='Beneficiários',ascending= False).reset_index(drop=True).head(10)
dt_recorrente = dt_recorrente.sort_values(by='qtdReclamacoes',ascending= False).reset_index(drop=True)
#estruturando o grafico
chart_rank = df['Subtema Demanda'].value_counts().head(5)
chart_rank_bar = px.bar(
        chart_rank
        ,x=chart_rank.index.str[:25]
        ,y=chart_rank.values
        ,title="Top 5 - Ranking Subtema"
        ,text=chart_rank.values
        ,labels={
            "y":"Qtd. Reclamações →"
            ,"x":"Subtema →"
        }
    )
chart_beneficiario =  beneficiario.groupby("Planos")["Beneficiários"].sum().reset_index().sort_values("Beneficiários", ascending=False)
chart_beneficiario_bar = px.bar(
        chart_beneficiario
        ,x="Planos"
        ,y="Beneficiários"
        ,title="Top 10 - Plano x Beneficiários"
        ,text="Beneficiários"
    )
chart_dt_recorrente =  dt_recorrente.groupby("Data Atendimento")["qtdReclamacoes"].sum().reset_index().sort_values("qtdReclamacoes", ascending=False)
chart_dt_recorrente_bar = px.bar(
        chart_dt_recorrente
        ,x="Data Atendimento"
        ,y="qtdReclamacoes"
        ,title="Top 10 - Datas Recorrentes"
        ,text="qtdReclamacoes"
    )
#print
print("-"*100)
print("Ranking de Reclamações")
print("-"*100)
print(rank)
print(chart_rank_bar.show())
print("-"*100)
print("Top 10 - Plano x Qtd Reclamação")
print("-"*100)
print(plano)
print("-"*100)
print("Top 10 - Plano x Beneficiários")
print("-"*100)
print(beneficiario)
print(chart_beneficiario_bar.show())
print("-"*100)
print("Top 10 - Datas Recorrentes")
print("-"*100)
print(dt_recorrente)
print(chart_dt_recorrente_bar.show())
```

For more details see [GitHub Flavored Markdown](https://guides.github.com/features/mastering-markdown/).

### Jekyll Themes

Your Pages site will use the layout and styles from the Jekyll theme you have selected in your [repository settings](https://github.com/Jameskelsom/promobit/settings). The name of this theme is saved in the Jekyll `_config.yml` configuration file.

### Support or Contact

Having trouble with Pages? Check out our [documentation](https://docs.github.com/categories/github-pages-basics/) or [contact support](https://github.com/contact) and we’ll help you sort it out.
