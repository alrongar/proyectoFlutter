const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");

admin.initializeApp();

// Ejecutar esta función cada 10 minutos
exports.enviarRecordatorioEvento = functions.pubsub
    .schedule("every 10 minutes")
    .timeZone("Europe/Madrid")
    .onRun(async (context) => {
      const ahora = Date.now();
      const unaHoraDespues = ahora + 3600 * 1000;

      console.log(`Buscando eventos entre:
      ${new Date(ahora).toISOString()} y
      ${new Date(unaHoraDespues).toISOString()}`);

      try {
        const eventosSnapshot = await admin.firestore()
            .collection("eventos")
            .where("startTime", ">=", admin.firestore.Timestamp.fromMillis(ahora))
            .where("startTime", "<=", admin.firestore.Timestamp.fromMillis(unaHoraDespues))
            .get();

        if (eventosSnapshot.empty) {
          console.log("No se encontraron eventos próximos.");
          return null;
        }

        console.log(`Eventos encontrados: ${eventosSnapshot.size}`);

        // Procesar cada evento encontrado
        for (const eventoDoc of eventosSnapshot.docs) {
          const eventoRef = eventoDoc.ref;
          const eventoData = eventoDoc.data();
          const usuariosRegistrados = eventoData.registeredUsers || [];
          const tituloEvento = eventoData.title || "Evento sin título";

          if (!Array.isArray(usuariosRegistrados) || usuariosRegistrados.length === 0) {
            console.log(`Evento "${tituloEvento}" sin usuarios registrados. Eliminando...`);
            await eventoRef.delete();
            continue;
          }

          console.log(`Procesando evento "${tituloEvento}" con ${usuariosRegistrados.length} usuarios`);

          let exitos = 0;
          let fallos = 0;

          // Enviar notificaciones y manejar errores
          for (const token of usuariosRegistrados) {
            try {
              if (typeof token !== "string" || !token.startsWith("c")) {
                throw new Error("Token con formato inválido");
              }

              await admin.messaging().send({
                notification: {
                  title: "¡El evento está a punto de comenzar!",
                  body: `${tituloEvento} comienza en 1 hora`,
                },
                token: token,
              });

              exitos++;
              console.log(`Notificación enviada a ${token.substring(0, 10)}...`);
            } catch (error) {
              fallos++;
              console.error(`Error en ${token.substring(0, 10)}...: ${error.message}`);
            }
          }

          // Eliminar el evento completo después de procesar
          await eventoRef.delete();
          console.log(`Evento "${tituloEvento}" eliminado. Resumen: ${exitos} exitos, ${fallos} fallos`);
        }
      } catch (error) {
        console.error("Error crítico al procesar eventos:", error.message);
      }
    });