--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll


--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "favico.ico" $ do
        route idRoute
        compile copyFileCompiler
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler
    match "images/badges/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match (fromList ["about.markdown"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match "cultivos/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/cultivo.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls
    create ["cultivos.html"] $ do
        route idRoute
        compile $ do
            posts <- loadAll "cultivos/*"
            let archiveCtx =
                    listField "cultivos" postCtx (return posts) `mappend`
                    constField "header" "Cultivos"            `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/cultivos.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls

    match "produtos/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/produto.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls
    create ["produtos.html"] $ do
        route idRoute
        compile $ do
            posts <- loadAll "produtos/*"
            let archiveCtx =
                    listField "produtos" postCtx (return posts) `mappend`
                    constField "header" "Produtos"            `mappend`
                    defaultContext
            makeItem ""
                >>= loadAndApplyTemplate "templates/produtos.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls

    match "receitas/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/receita.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls
    create ["receitas.html"] $ do
        route idRoute
        compile $ do
            posts <- loadAll "receitas/*"
            let archiveCtx =
                    listField "receitas" postCtx (return posts) `mappend`
                    constField "header" "Receitas"            `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/receitas.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls

    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    create ["posts.html"] $ do
        route idRoute
        compile $ do
            posts <- loadAll "posts/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "header" "Blog"            `mappend`
                    defaultContext
            makeItem ""
                >>= loadAndApplyTemplate "templates/posts.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls

    match "eventos/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/evento.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    create ["eventos.html"] $ do
        route idRoute
        compile $ do
            posts <- loadAll "eventos/*"
            let archiveCtx =
                    listField "eventos" postCtx (return posts) `mappend`
                    constField "header" "Eventos"            `mappend`
                    defaultContext
            makeItem ""
                >>= loadAndApplyTemplate "templates/eventos.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls

    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- loadAll "cultivos/*"
            let indexCtx =
                    listField "cultivos" postCtx (return posts) `mappend`
                    constField "header" "Home"                `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    metadataField `mappend`
    defaultContext
