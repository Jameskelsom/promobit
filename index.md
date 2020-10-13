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

**![Image](https://github.com/Jameskelsom/promobit/blob/gh-pages/pbi.png)**

### Teste 2
Fazer a mesma coisa, mas agora com um notebook python
Utilizar o estilo de gráfico que faça mais sentido com os dados apresentados.

```markdown
- code:
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
**![Resultado](https://github.com/Jameskelsom/promobit/blob/gh-pages/py.png)**

### Teste 3
**Resolver o seguinte problema no [hackerrank](https://www.hackerrank.com/challenges/interviews/problem)**
```markdown
select
    cts.contest_id
    ,cts.hacker_id
    ,cts.name
    ,sum(chg.total_submissions) total_submissions
    ,sum(chg.total_accepted_submissions) total_accepted_submissions
    ,sum(chg.total_views) total_views
    ,sum(chg.total_unique_views) total_unique_views
from contests cts
left join colleges clg on cts.contest_id=clg.contest_id 
left join (
    select
        distinct c.college_id 
        ,sum(ss.total_submissions) as total_submissions
        ,sum(ss.total_accepted_submissions) as total_accepted_submissions
        ,sum(vs.total_views) as total_views
        ,sum(vs.total_unique_views) as total_unique_views
    from challenges c
    LEFT JOIN (
        select
            challenge_id
            ,sum(total_submissions) total_submissions
            ,sum(total_accepted_submissions) total_accepted_submissions
        from Submission_Stats
        group by challenge_id
        ) ss ON ss.challenge_id = c.challenge_id
    left join (
        select
            challenge_id
            ,sum(total_views) total_views
            ,sum(total_unique_views) total_unique_views
        from View_Stats
        group by challenge_id
    ) vs on vs.challenge_id=c.challenge_id 
    group by c.college_id 
) chg on clg.college_id=chg.college_id
group by cts.contest_id
    ,cts.hacker_id
    ,cts.name
having sum(ifnull(chg.total_submissions,0)
    +ifnull(chg.total_accepted_submissions,0)
    +ifnull(chg.total_views,0)
    +ifnull(chg.total_unique_views,0))>0
    order by cts.contest_id;
```
